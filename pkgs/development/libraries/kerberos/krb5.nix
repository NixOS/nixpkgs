{
  lib,
  stdenv,
  fetchurl,
  bootstrap_cmds,
  byacc, # can also use bison, but byacc has fewer dependencies
  keyutils,
  openssl,
  bashNonInteractive,
  perl,
  pkg-config,

  # for passthru.tests
  bind,
  curl,
  nixosTests,
  openssh,
  postgresql,
  python3,

  # Extra Arguments
  withLdap ? false,
  openldap,
  withLibedit ? true,
  libedit,
  withVerto ? false,
  libverto,

  # This is called "staticOnly" because krb5 does not support
  # builting both static and shared, see below.
  staticOnly ? false,
}:

stdenv.mkDerivation rec {
  pname = "krb5";
  version = "1.22.1";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://kerberos.org/dist/krb5/${lib.versions.majorMinor version}/krb5-${version}.tar.gz";
    hash = "sha256-GogyuMrZI+u/E5T2fi789B46SfRgKFpm41reyPoAU68=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  # While "out" acts as the bin output, most packages only care about the lib output.
  # We set prefix such that all the pkg-config configuration stays inside the dev and lib outputs.
  # stdenv will take care of overriding bindir, sbindir, etc. such that "out" contains the binaries.
  prefix = placeholder "lib";

  env = {
    # The release 1.21.3 is not compatible with c23, which changed the meaning of
    #
    #     void foo();
    #
    # declaration.
    NIX_CFLAGS_COMPILE = "-std=gnu17" + lib.optionalString stdenv.hostPlatform.isStatic " -fcommon";
  };

  configureFlags = [
    "--localstatedir=/var/lib"
    (lib.withFeature withLdap "ldap")
    (lib.withFeature withLibedit "libedit")
    (lib.withFeature withVerto "system-verto")
  ]
  # krb5's ./configure does not allow passing --enable-shared and --enable-static at the same time.
  # See https://bbs.archlinux.org/viewtopic.php?pid=1576737#p1576737
  ++ lib.optionals staticOnly [
    "--enable-static"
    "--disable-shared"
  ]
  ++ lib.optional stdenv.hostPlatform.isFreeBSD ''WARN_CFLAGS=''
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "krb5_cv_attr_constructor_destructor=yes,yes"
    "ac_cv_func_regcomp=yes"
    "ac_cv_printf_positional=yes"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    byacc
    perl
    pkg-config
  ]
  # Provides the mig command used by the build scripts
  ++ lib.optional stdenv.hostPlatform.isDarwin bootstrap_cmds;

  buildInputs = [
    openssl
    bashNonInteractive # cannot use bashInteractive because of a dependency cycle
  ]
  ++ lib.optionals (
    stdenv.hostPlatform.isLinux
    && stdenv.hostPlatform.libc != "bionic"
    && !(stdenv.hostPlatform.useLLVM or false)
  ) [ keyutils ]
  ++ lib.optionals withLdap [ openldap ]
  ++ lib.optionals withLibedit [ libedit ]
  ++ lib.optionals withVerto [ libverto ];

  sourceRoot = "krb5-${version}/src";

  postPatch = ''
    substituteInPlace config/shlib.conf \
      --replace "'ld " "'${stdenv.cc.targetPrefix}ld "
  ''
  # this could be accomplished by updateAutotoolsGnuConfigScriptsHook, but that causes infinite recursion
  # necessary for FreeBSD code path in configure
  + ''
    substituteInPlace ./config/config.guess --replace-fail /usr/bin/uname uname
  '';

  libFolders = [
    "util"
    "include"
    "lib"
    "build-tools"
  ];

  # To avoid cyclic outputs, we can't let lib depend on out in any way. Unfortunately, the configure
  # options don't give us enough granularity to specify that, so we have to override the generated
  # Makefiles manually.
  postConfigure = ''
    find "''${libFolders[@]}" -type f -name Makefile -print0 | while IFS= read -rd "" f; do
      substituteInPlace "$f" --replace-fail "$out" "$lib"
    done
  '';

  preInstall = ''
    mkdir -p "$lib"/{bin,sbin,lib/pkgconfig,share/{et,man/man1}}
  '';

  postInstall = ''
    # not via outputBin, due to reference from libkrb5.so
    moveToOutput bin/krb5-config "$dev"
    moveToOutput sbin/krb5-send-pr "$out"
    moveToOutput bin/compile_et "$out"
  '';

  # Disable _multioutDocs in stdenv by overriding it to be a no-op.
  # We do this because $lib has its own docs and we don't want to squash them into $out.
  preFixup = ''
    _multioutDocs() {
      echo Skipping multioutDocs
    }
  '';

  enableParallelBuilding = true;
  doCheck = false; # fails with "No suitable file for testing purposes"

  outputChecks.lib.disallowedRequisites = [
    # bash cannot be here because of a dependency cycle
    bashNonInteractive
  ];

  meta = with lib; {
    description = "MIT Kerberos 5";
    homepage = "http://web.mit.edu/kerberos/";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };

  passthru = {
    implementation = "krb5";
    tests = {
      inherit (nixosTests) kerberos;
      inherit (python3.pkgs) requests-credssp;
      bind = bind.override { enableGSSAPI = true; };
      curl = curl.override { gssSupport = true; };
      openssh = openssh.override { withKerberos = true; };
      postgresql = postgresql.override { gssSupport = true; };
    };
  };
}
