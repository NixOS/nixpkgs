{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "jitterentropy";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    sha256 = "0n2l1fxr7bynnarpwdjifb2fvlsq8w5wmfh31yk5nrc756cjlgyw";
  };
  patches = [
    # Can be removed when upgrading beyond 2.2.0
    ./reproducible-manpages.patch
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/include
    substituteInPlace Makefile \
      --replace "install -m 0755 -s" \
                'install -m 0755 -s --strip-program $(STRIP)'
  '';

  installFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Provides a noise source using the CPU execution timing jitter";
    homepage = https://github.com/smuellerDD/jitterentropy-library;
    license = with stdenv.lib.licenses; [ gpl2 bsd3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ johnazoidberg ];
  };
}
