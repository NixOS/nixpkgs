{ lib
, buildPythonPackage
, fetchFromGitHub
, migen
, packaging
, requests
, pyserial
}:

buildPythonPackage rec {
  pname = "litex";
  version = "2023.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litex";
    rev = version;
    hash = "sha256-XXcYrCyFysglKT8AChyOT8rweG6IChEpueL+SFKc1Aw=";
  };

  propagatedBuildInputs = [ migen packaging requests pyserial ];

  pythonImportsCheck = [ "litex" ];

  # Tests are broken due to misimporting migen?
  doCheck = false;

  meta = with lib; {
    description = "Build your hardware, easily";
    homepage = "https://github.com/enjoy-digital/litex";
    changelog = "https://github.com/enjoy-digital/litex/blob/${src.rev}/CHANGES.md";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ raitobezarius ];
  };
}
