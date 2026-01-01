{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hcloud";
<<<<<<< HEAD
  version = "2.13.0";
=======
  version = "2.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-l0sio2w0fhE/+LJavSzThoARKISFGStWJynbprIjdeE=";
=======
    hash = "sha256-8hL+H1PL+J7d2sDnAF7C6wIep4n4K+cJe9dM1wWynys=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hcloud" ];

<<<<<<< HEAD
  meta = {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liff ];
=======
  meta = with lib; {
    description = "Library for the Hetzner Cloud API";
    homepage = "https://github.com/hetznercloud/hcloud-python";
    changelog = "https://github.com/hetznercloud/hcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ liff ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
