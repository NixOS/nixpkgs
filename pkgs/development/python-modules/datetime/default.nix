{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytz,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "datetime";
<<<<<<< HEAD
  version = "6.0";
=======
  version = "5.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-bxFdj9B0LUbnn/q5RcO3tBwqAMMl3Ovom036y0yfUbE=";
=======
    hash = "sha256-VgIEpa3WpxfIUpBjXMor/xEEu+sp7z/EsLYEvU0RzWk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    pytz
    zope-interface
  ];

  pythonImportsCheck = [ "DateTime" ];

<<<<<<< HEAD
  meta = {
    description = "DateTime data type, as known from Zope";
    homepage = "https://github.com/zopefoundation/DateTime";
    changelog = "https://github.com/zopefoundation/DateTime/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ icyrockcom ];
=======
  meta = with lib; {
    description = "DateTime data type, as known from Zope";
    homepage = "https://github.com/zopefoundation/DateTime";
    changelog = "https://github.com/zopefoundation/DateTime/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ icyrockcom ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
