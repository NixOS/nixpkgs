{ stdenv, buildPythonPackage, fetchurl, pytest, isPy3k }:
buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pytest-asyncio";
  version = "0.8.0";

  disabled = !isPy3k;

  src = fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "f32804bb58a66e13a3eda11f8942a71b1b6a30466b0d2ffe9214787aab0e172e";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "library for testing asyncio code with pytest";
    license = licenses.asl20;
    homepage = https://github.com/pytest-dev/pytest-asyncio;
  };
}
