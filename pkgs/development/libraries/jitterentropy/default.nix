{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "jitterentropy-${version}";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "jitterentropy-library";
    rev = "v${version}";
    sha256 = "10yl1hi0hysr53wzy2i8brs0qqnxh46mz3dcjh5mk0ad03wvbfsl";
  };

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/include
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
