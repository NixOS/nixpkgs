{ stdenv, fetchFromGitHub
, cmake, flex, bison
, libxml2
}:

stdenv.mkDerivation rec {
  name = "libiio-${version}";
  version = "0.15";

  src = fetchFromGitHub {
    owner  = "analogdevicesinc";
    repo   = "libiio";
    rev    = "refs/tags/v${version}";
    sha256 = "05sbvvjka03qi080ad6g2y6gfwqp3n3zv7dpv237dym0zjyxqfa7";
  };

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ libxml2 ];

  meta = with stdenv.lib; {
    description = "API for interfacing with the Linux Industrial I/O Subsystem";
    homepage    = https://github.com/analogdevicesinc/libiio;
    license     = licenses.lgpl21;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
