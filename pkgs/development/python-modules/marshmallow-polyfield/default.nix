{ lib
, buildPythonPackage
, fetchPypi
, six
, marshmallow
, pytest
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72980cb9a43a7c750580b4b08e9d01a8cbd583e1f59360f1924a1ed60f065a4c";
  };

  propagatedBuildInputs = [
    six
    marshmallow
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = "py.test tests";

  meta = {
    homepage = "https://github.com/Bachmann1234/marshmallow-polyfield";
    description = "An extension to marshmallow to allow for polymorphic fields";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      pandaman
    ];
  };
}
