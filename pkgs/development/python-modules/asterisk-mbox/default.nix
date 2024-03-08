{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch2
, setuptools
, packaging
}:

buildPythonPackage rec {
  pname = "asterisk-mbox";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "asterisk_mbox";
    inherit version;
    hash = "sha256-BiT5q4XOnE1DZV+GU+hTn6EMgbYP17lLGhXc4wbCCIg=";
  };

  patches = [
    # https://github.com/PhracturedBlue/asterisk_mbox/pull/1
    (fetchpatch2 {
      name = "distutils-deprecated.patch";
      url = "https://github.com/PhracturedBlue/asterisk_mbox/commit/bab84525306a0c41aadd3aab4ebba7c062253d07.patch";
      hash = "sha256-2j7jIl3Ydn2dHJhEzu/77Zkxhw58NIebgULifpTVidY=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    packaging
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "asterisk_mbox" ];

  meta = with lib; {
    description = "The client side of a client/server to interact with Asterisk voicemail mailboxes";
    homepage = "https://github.com/PhracturedBlue/asterisk_mbox";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
