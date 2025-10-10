{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiofiles,
  click,
  tomli,
  pytest-mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "w1thermsensor";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n7wK4N1mzZtUxtYu17qyuI4UjJh/59UGD0dvkOgcInA=";
  };

  postPatch = ''
    sed -i 's/3\.5\.\*/3.5/' setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ click ];

  optional-dependencies = {
    async = [ aiofiles ];
  };

  # Don't try to load the kernel module in tests.
  env.W1THERMSENSOR_NO_KERNEL_MODULE = 1;

  nativeCheckInputs = [
    pytest-mock
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "w1thermsensor" ];

  meta = with lib; {
    description = "Python interface to 1-Wire temperature sensors";
    mainProgram = "w1thermsensor";
    longDescription = ''
      A Python package and CLI tool to work with w1 temperature sensors like
      DS1822, DS18S20 & DS18B20 on the Raspberry Pi, Beagle Bone and other
      devices.
    '';
    homepage = "https://github.com/timofurrer/w1thermsensor";
    changelog = "https://github.com/timofurrer/w1thermsensor/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ quentin ];
    platforms = platforms.all;
  };
}
