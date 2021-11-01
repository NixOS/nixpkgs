{ lib
, buildPythonPackage
, fetchPypi
, entry-points-txt
, six
}:

buildPythonPackage rec {
  pname = "headerparser";
  version = "0.4.0";

  src = fetchPypi{
    inherit pname;
    inherit version;
    sha256 = "b8ceae4c5e6133fda666d022684e93f9b3d45815c2c7881018123c71ff28c5cc";
  };

  buildInputs = [
    six
  ];

  meta = with lib; {
    homepage = "https://github.com/jwodder/headerparser";
    description = "argparse for mail-style headers";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
