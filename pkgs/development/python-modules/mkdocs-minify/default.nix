{ lib
, callPackage
, buildPythonApplication
, fetchFromGitHub
, mkdocs
, csscompressor
, htmlmin
, jsmin
}:

buildPythonApplication rec {
  pname = "mkdocs-minify";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "byrnereese";
    repo = "${pname}-plugin";
    rev = version;
    sha256 = "sha256-7v4uX711KAKuXFeVdLuIdGQi2i+dL4WX7+Zd4H1L3lM=";
  };

  propagatedBuildInputs = [
    csscompressor
    htmlmin
    jsmin
    mkdocs
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "A mkdocs plugin to minify the HTML of a page before it is written to disk.";
    homepage = "https://github.com/byrnereese/mkdocs-minify-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
