{ buildPythonPackage
, fetchFromGitHub
, lib
, pytest
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "Rx";
  version = "3.0.1";

  disabled = pythonOlder "3.6";

  # There are no tests on the pypi source
  src = fetchFromGitHub {
    owner = "ReactiveX";
    repo = "rxpy";
    rev = "v${version}";
    sha256 = "15flv8vdd8j1v58m3bhlnvmi1hfj2vz0ir6vk7z4wq613hyrx7ix";
  };

  checkInputs = [ pytest pytest-asyncio ];

  # Some tests are nondeterministic. (`grep sleep -r tests`)
  doCheck = false;

  meta = {
    homepage = "https://rxpy.rtfd.io";
    description = "Reactive Extensions for Python";
    maintainers = with lib.maintainers; [ thanegill ];
    license = lib.licenses.mit;
  };
}
