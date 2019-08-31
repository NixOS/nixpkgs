{ fetchFromGitHub, pythonPackages, lib }:

pythonPackages.buildPythonPackage rec {
  pname = "nototools";
  version = "unstable-2019-03-20";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "9c4375f07c9adc00c700c5d252df6a25d7425870";
    sha256 = "0z9i23vl6xar4kvbqbc8nznq3s690mqc5zfv280l1c02l5n41smc";
  };

  propagatedBuildInputs = with pythonPackages; [ fonttools numpy ];

  postPatch = ''
    sed -ie "s^join(_DATA_DIR_PATH,^join(\"$out/third_party/ucd\",^" nototools/unicode_data.py
  '';

  postInstall = ''
    cp -r third_party $out
  '';

  disabled = pythonPackages.isPy3k;

  meta = {
    description = "Noto fonts support tools and scripts plus web site generation";
    license = lib.licenses.asl20;
    homepage = https://github.com/googlefonts/nototools;
  };
}
