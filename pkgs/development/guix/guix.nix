{stdenv, fetchurl}:
stdenv.mkDerivation rec
  { name = "guix-${version}";
    version = "1.0.0";

    src = fetchurl {
      url = "https://ftp.gnu.org/gnu/guix/guix-binary-${version}.${stdenv.targetPlatform.system}.tar.xz";
      sha256 = {
        "x86_64-linux" = "11y9nnicd3ah8dhi51mfrjmi8ahxgvx1mhpjvsvdzaz07iq56333";
        "i686-linux" = "14qkz12nsw0cm673jqx0q6ls4m2bsig022iqr0rblpfrgzx20f0i";
        "aarch64-linux" = "0qzlpvdkiwz4w08xvwlqdhz35mjfmf1v3q8mv7fy09bk0y3cwzqs";
        }."${stdenv.targetPlatform.system}";
    };
    sourceRoot = ".";

    outputs = [ "out" "store" "var" ];
    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      # copy the /gnu/store content
      mkdir -p $store
      cp -r gnu $store

      # copy /var content
      mkdir -p $var
      cp -r var $var

      # link guix binaries
      mkdir -p $out/bin
      ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix $out/bin/guix
      ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix-daemon $out/bin/guix-daemon
    '';

    meta = with stdenv.lib; {
      description = "The GNU Guix package manager";
      homepage = https://www.gnu.org/software/guix/;
      license = licenses.gpl3Plus;
      maintainers = [ maintainers.johnazoidberg ];
      platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
    };

  }
