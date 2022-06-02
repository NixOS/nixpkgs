{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nats-python";
  version = "0.8.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Gr1N";
    repo = "nats-python";
    rev = version;
    sha256 = "1j7skyxldir3mphvnsyhjxmf3cimv4h7n5v58jl2gff4yd0hdw7g";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  patches = [
    # Switch to poetry-core, https://github.com/Gr1N/nats-python/pull/19
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/Gr1N/nats-python/commit/71b25b324212dccd7fc06ba3914491adba22e83f.patch";
      sha256 = "1fip1qpzk2ka7qgkrdpdr6vnrnb1p8cwapa51xp0h26nm7yis1gl";
    })
  ];

  # Tests require a running NATS server
  doCheck = false;

  pythonImportsCheck = [ "pynats" ];

  meta = with lib; {
    description = "Python client for NATS messaging system";
    homepage = "https://github.com/Gr1N/nats-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
