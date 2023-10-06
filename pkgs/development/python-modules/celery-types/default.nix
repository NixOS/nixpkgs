{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, poetry-core
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "celery-types";
  version = "0.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1OLUJxsuxG/sCKDxKiU4i7o5HyaJdIW8rPo8UofMI28=";
  };

  patches = [
    # remove extraneous build dependencies:
    # https://github.com/sbdchd/celery-types/pull/138
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/sbdchd/celery-types/commit/ff83f06a0302084e1a690e2a5a8b25f2c0dfc6e7.patch";
      hash = "sha256-c68SMugg6Qk88FC842/czoxLpk0uVAVSlWsvo4NI9uo=";
    })
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  doCheck = false;

  meta = with lib; {
    description = "PEP-484 stubs for Celery";
    homepage = "https://github.com/sbdchd/celery-types";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
