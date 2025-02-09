{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, arrow
, freezegun
, jinja2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jinja2-time";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0dr7cfpjnjj8bgl2vk9063a53649pn37wnlkd8hxjy656slkni";
  };

  patches = [
    # fix usage of arrow in tests
    (fetchpatch {
      url = "https://github.com/hackebrot/jinja2-time/pull/19/commits/3b2476c266ba53262352153104ca3501722823a4.patch";
      hash = "sha256-zh4PpAj2GtpgaEap/Yvu6DNY84AwH/YTJlUPRRHPyTs=";
    })
  ];

  propagatedBuildInputs = [ arrow jinja2 ];

  nativeCheckInputs = [ freezegun pytestCheckHook ];

  pythonImportsCheck = [ "jinja2_time" ];

  meta = with lib; {
    homepage = "https://github.com/hackebrot/jinja2-time";
    description = "Jinja2 Extension for Dates and Times";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
