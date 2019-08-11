{ fetchFromGitHub, pythonPackages, lib }:

pythonPackages.buildPythonPackage rec {
  version = "2017-09-25";
  name = "nototools-${version}";

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "nototools";
    rev = "v2017-09-25-tooling-for-phase3-update";
    sha256 = "03nzvcvwmrhfrcjhg218q2f3hfrm3vlivp4rk19sc397kh3hisiz";
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
    homepage = https://github.com/googlei18n/nototools;
  };
}
