{
  stdenv,
  nixosTests,
  lib,
  pkg-config,
  jansson,
  pcre2,
  libxcrypt,
  expat,
  zlib,
  # plugins: list of strings, eg. [ "python3" ]
  plugins ? [ ],
  pam,
  withPAM ? stdenv.hostPlatform.isLinux,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  libcap,
  withCap ? stdenv.hostPlatform.isLinux,
  python3,
  ncurses,
  ruby,
  php,
  makeWrapper,
  fetchFromGitHub,
}:

let
  php-embed = php.override {
    embedSupport = true;
    apxs2Support = false;
  };

  available = lib.listToAttrs [
    (lib.nameValuePair "python3" {
      interpreter = python3.pythonOnBuildForHost.interpreter;
      path = "plugins/python";
      inputs = [
        python3
        ncurses
      ];
      install = ''
        install -Dm644 uwsgidecorators.py $out/${python3.sitePackages}/uwsgidecorators.py
        ${python3.pythonOnBuildForHost.executable} -m compileall $out/${python3.sitePackages}/
        ${python3.pythonOnBuildForHost.executable} -O -m compileall $out/${python3.sitePackages}/
      '';
    })
    (lib.nameValuePair "rack" {
      path = "plugins/rack";
      inputs = [ ruby ];
    })
    (lib.nameValuePair "cgi" {
      # usage: https://uwsgi-docs.readthedocs.io/en/latest/CGI.html?highlight=cgi
      path = "plugins/cgi";
      inputs = [ ];
    })
    (lib.nameValuePair "php" {
      # usage: https://uwsgi-docs.readthedocs.io/en/latest/PHP.html#running-php-apps-with-nginx
      path = "plugins/php";
      inputs = [
        php-embed
        php-embed.extensions.session
        php-embed.extensions.session.dev
        php-embed.unwrapped.dev
      ]
      ++ php-embed.unwrapped.buildInputs;
    })
  ];

  getPlugin =
    name:
    let
      all = lib.concatStringsSep ", " (lib.attrNames available);
    in
    if lib.hasAttr name available then
      lib.getAttr name available // { inherit name; }
    else
      throw "Unknown UWSGI plugin ${name}, available : ${all}";

  needed = builtins.map getPlugin plugins;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "uwsgi";
  version = "2.0.30";

  src = fetchFromGitHub {
    owner = "unbit";
    repo = "uwsgi";
    tag = finalAttrs.version;
    hash = "sha256-I03AshxZyxrRmtYUH1Q+B6ISykjYRMGG+ZQSHRS7vDs=";
  };

  patches = [
    ./no-ext-session-php_session.h-on-NixOS.patch
    ./additional-php-ldflags.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    jansson
    pcre2
    libxcrypt
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    expat
    zlib
  ]
  ++ lib.optional withPAM pam
  ++ lib.optional withSystemd systemd
  ++ lib.optional withCap libcap
  ++ lib.concatMap (x: x.inputs) needed;

  basePlugins = lib.concatStringsSep "," (
    lib.optional withPAM "pam" ++ lib.optional withSystemd "systemd_logger"
  );

  UWSGI_INCLUDES = lib.optionalString withCap "${libcap.dev}/include";

  passthru = {
    inherit python3;
    tests.uwsgi = nixosTests.uwsgi;
  };

  postPatch = ''
    for f in uwsgiconfig.py plugins/*/uwsgiplugin.py; do
      substituteInPlace "$f" \
        --replace pkg-config "$PKG_CONFIG"
    done
    sed -e "s/ + php_version//" -i plugins/php/uwsgiplugin.py
  '';

  configurePhase = ''
    runHook preConfigure

    export pluginDir=$out/lib/uwsgi
    substituteAll ${./nixos.ini} buildconf/nixos.ini

    runHook postConfigure
  '';

  # this is a hack to make the php plugin link with session.so (which on nixos is a separate package)
  # the hack works in coordination with ./additional-php-ldflags.patch
  UWSGICONFIG_PHP_LDFLAGS = lib.optionalString (builtins.any (x: x.name == "php") needed) (
    lib.concatStringsSep "," [
      "-Wl"
      "-rpath=${php-embed.extensions.session}/lib/php/extensions/"
      "--library-path=${php-embed.extensions.session}/lib/php/extensions/"
      "-l:session.so"
    ]
  );

  buildPhase = ''
    runHook preBuild

    mkdir -p $pluginDir
    python3 uwsgiconfig.py --build nixos
    ${lib.concatMapStringsSep ";" (
      x:
      "${x.preBuild or ""}\n ${x.interpreter or "python3"} uwsgiconfig.py --plugin ${x.path} nixos ${x.name}"
    ) needed}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 uwsgi $out/bin/uwsgi
    ${lib.concatMapStringsSep "\n" (x: x.install or "") needed}

    runHook postInstall
  '';

  postFixup = lib.optionalString (builtins.any (x: x.name == "php") needed) ''
    wrapProgram $out/bin/uwsgi --set PHP_INI_SCAN_DIR ${php-embed}/lib
  '';

  meta = {
    description = "Fast, self-healing and developer/sysadmin-friendly application container server coded in pure C";
    homepage = "https://uwsgi-docs.readthedocs.org/en/latest/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      schneefux
      globin
    ];
    platforms = lib.platforms.unix;
    mainProgram = "uwsgi";
  };
})
