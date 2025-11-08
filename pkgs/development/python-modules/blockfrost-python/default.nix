{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  # Python deps
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blockfrost-python";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blockfrost";
    repo = "blockfrost-python";
    tag = version;
    hash = "sha256-mN26QXxizDR+o2V5C2MlqVEbRns1BTmwZdUnnHNcFzw=";
  };

  patches = [
    (fetchpatch2 {
      name = "blockfrost-python-fix-version";
      url = "https://github.com/blockfrost/blockfrost-python/commit/02fdc67ff6d1333c0855e740114585852bbfa0bc.patch?full_index=1";
      hash = "sha256-070tnWxOnVNsCYXmBFo39JUgQDqphdpqx3A9OIuC94U=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  pythonImportsCheck = [ "blockfrost" ];

  meta = with lib; {
    description = "Python SDK for the Blockfrost.io API";
    homepage = "https://github.com/blockfrost/blockfrost-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ aciceri ];
  };
}
