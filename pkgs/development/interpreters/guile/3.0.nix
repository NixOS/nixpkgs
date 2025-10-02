{
  lib,
  stdenv,
  pkgsBuildBuild,
  fetchpatch,
  writeScript,
  autoreconfHook,
  libxcrypt,
  libunistring,
  libtool,

  buildGuile,
  coverageAnalysis ? null,
}:

buildGuile (finalAttrs: {
  version = "3.0.10";
  srcHash = "sha256-Lb28l1mLL68xATVk77SOT+1EEx0o6ZbCar6KWyO1bCo=";

  patches =
    # Fix cross-compilation, can be removed at next release (as well as the autoreconfHook)
    # Include this only conditionally so we don't have to run the autoreconfHook for the native build.
    lib.optional (!lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform) (fetchpatch {
      url = "https://cgit.git.savannah.gnu.org/cgit/guile.git/patch/?id=c117f8edc471d3362043d88959d73c6a37e7e1e9";
      hash = "sha256-GFwJiwuU8lT1fNueMOcvHh8yvA4HYHcmPml2fY/HSjw=";
    })
    ++ lib.optional (coverageAnalysis != null) ./gcov-file-name.patch
    ++ lib.optional stdenv.hostPlatform.isDarwin (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      hash = "sha256-BwgdtWvRgJEAnzqK2fCQgRHU0va50VR6SQfJpGzjm4s=";
    });

  depsBuildBuild = lib.optional (
    !lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform
  ) pkgsBuildBuild.guile_3_0;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxcrypt
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxcrypt
  ];

  # At least on x86_64-darwin '-flto' autodetection is not correct:
  #  https://github.com/NixOS/nixpkgs/pull/160051#issuecomment-1046193028
  configureFlags = lib.optional (stdenv.hostPlatform.isDarwin) "--disable-lto";

  # XXX: See http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/18903 for
  # why `--with-libunistring-prefix' and similar options coming from
  # `AC_LIB_LINKFLAGS_BODY' don't work on NixOS/x86_64.
  postInstall = ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|-lcrypt|-L${libxcrypt}/lib -lcrypt|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;
            s|includedir=$out|includedir=$dev|g
            "
  '';

  # make check doesn't work on darwin
  # On Linuxes+Hydra the tests are flaky; feel free to investigate deeper.
  doCheck = false;
  doInstallCheck = finalAttrs.doCheck;

  setupHook = ./setup-hook-3.0.sh;

  passthru = {
    updateScript = writeScript "update-guile-3" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '"https://ftp.gnu.org/gnu/guile/guile-3.0.8.tar.gz"'
      new_version="$(curl -s https://www.gnu.org/software/guile/download/ |
          pcregrep -o1 '"https://ftp.gnu.org/gnu/guile/guile-(3[.0-9]+).tar.gz"')"
      update-source-version guile_3_0 "$new_version"
    '';
  };

  meta.maintainers = [ lib.maintainers.RossSmyth ];
})
