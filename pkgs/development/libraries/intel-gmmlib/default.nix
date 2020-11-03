{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "20.3.2";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "0727pr7sknqi859gb5z472kgbbwx40574iyls8fgirm7lcz6gbd9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/intel/gmmlib";
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ danieldk ];
  };
}
