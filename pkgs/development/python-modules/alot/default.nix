{ lib, buildPythonPackage, python, fetchFromGitHub, isPy3k, pytestCheckHook
, notmuch2, urwid, urwidtrees, twisted, python_magic, configobj, mock, file, gpgme
, service-identity, gnupg, sphinx, gawk, procps, future , withManpage ? false
}:

buildPythonPackage rec {
  pname = "alot";
  version = "0.10";
  outputs = [ "out" ] ++ lib.optional withManpage "man";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    rev = version;
    sha256 = "sha256-1reAq8X9VwaaZDY5UfvcFzHDKd71J88CqJgH3+ANjis=";
  };

  postPatch = ''
    substituteInPlace alot/settings/manager.py --replace /usr/share "$out/share"
  '';

  nativeBuildInputs = lib.optional withManpage sphinx;

  propagatedBuildInputs = [
    notmuch2
    urwid
    urwidtrees
    twisted
    python_magic
    configobj
    service-identity
    file
    gpgme
  ];

  postBuild = lib.optionalString withManpage "make -C docs man";

  checkInputs = [ gawk future mock gnupg procps pytestCheckHook ];
  # some twisted tests need internet access
  disabledTests = [
    "test_env_set"
    "test_no_spawn_no_stdin_attached"
  ];

  postInstall = let
    completionPython = python.withPackages (ps: [ ps.configobj ]);
  in lib.optionalString withManpage ''
    mkdir -p $out/man
    cp -r docs/build/man $out/man
  ''
  + ''
    mkdir -p $out/share/{applications,alot}
    cp -r extra/themes $out/share/alot

    substituteInPlace extra/completion/alot-completion.zsh \
      --replace "python3" "${completionPython.interpreter}"
    install -D extra/completion/alot-completion.zsh $out/share/zsh/site-functions/_alot

    sed "s,/usr/bin,$out/bin,g" extra/alot.desktop > $out/share/applications/alot.desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/pazz/alot";
    description = "Terminal MUA using notmuch mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edibopp ];
  };
}
