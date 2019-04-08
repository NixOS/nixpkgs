{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, multipledispatch
, numpy
}:

buildPythonPackage rec {
  version = "0.10.2";
  pname = "pyrr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q9i4qa6ygr8hlpnw55s58naynxzwm0sc1m54wyy1ghbf8m8d2f0";
  };

  buildInputs = [ setuptools ];
  propagatedBuildInputs = [ multipledispatch numpy ];

  meta = with stdenv.lib; {
    description = "3D mathematical functions using NumPy";
    homepage = https://github.com/adamlwgriffiths/Pyrr/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
