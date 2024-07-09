{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  beautifulsoup4,
  enum-compat,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "enocean";
  version = "0.60.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "enocean";
    rev = version;
    sha256 = "0cbcvvy3qaqv8925z608qmkc1l914crzw79krwrz2vpm2fyribab";
  };

  patches = [
    (fetchpatch2 {
      name = "replace-nose-with-pytest.patch";
      url = "https://github.com/kipe/enocean/commit/e5ca3b70f0920f129219c980ad549d7f3a4576de.patch";
      hash = "sha256-cDBvI0I4W5YkGTpg+rKy08TUAmKlhKa/5+Muou9iArs=";
    })
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    enum-compat
    pyserial
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "enocean.communicators"
    "enocean.protocol.packet"
    "enocean.utils"
  ];

  meta = with lib; {
    description = "EnOcean serial protocol implementation";
    mainProgram = "enocean_example.py";
    homepage = "https://github.com/kipe/enocean";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
