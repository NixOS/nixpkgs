{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "19.3.4";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "1vgh14vdmwr34l6rfzmbpsdwp4xi7qp8lg527p16pm7nv0bwx2zk";
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
