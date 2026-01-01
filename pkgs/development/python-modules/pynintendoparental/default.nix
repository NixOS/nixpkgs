{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
<<<<<<< HEAD
  pynintendoauth,
=======
  python-dotenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pynintendoparental";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "1.1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pynintendoparental";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-gq81cdI/HegNs1llQkC4GbEzHzvEs6f4MrBtIK/G2SE=";
  };

  postPatch = ''
    substituteInPlace pynintendoparental/_version.py \
      --replace-fail '__version__ = "0.0.0"' '__version__ = "${version}"'
  '';

=======
    hash = "sha256-mH34BcbK3qyB2sAmVyAQz6GhI+xWAdRHagZzLVI9gr8=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [
    aiohttp
<<<<<<< HEAD
    pynintendoauth
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "pynintendoparental" ];

  # test.py connects to the actual API
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pynintendoparental/releases/tag/${src.tag}";
    description = "Python module to interact with Nintendo Parental Controls";
    homepage = "https://github.com/pantherale0/pynintendoparental";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
