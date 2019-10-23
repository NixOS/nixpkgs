{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "19.3.2";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "04jmzyciswvfb31h9shkja9183bmm1clw0l0sn1flq76888nngma";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/gmmlib;
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
