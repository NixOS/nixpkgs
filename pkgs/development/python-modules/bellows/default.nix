{
  lib,
  buildPythonPackage,
  click,
  click-log,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "bellows";
<<<<<<< HEAD
  version = "0.48.2";
=======
  version = "0.47.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-igv/F65oZKYj8hd9KCYlbz6Yf9Ny1lnW4yFs0XT4waQ=";
=======
    hash = "sha256-1gWmXrRCYmU0VemhW5TCn1/rnOmz07q8bQ6W3a2mXro=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    click
    click-log
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "bellows" ];

<<<<<<< HEAD
  meta = {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
=======
  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bellows";
  };
}
