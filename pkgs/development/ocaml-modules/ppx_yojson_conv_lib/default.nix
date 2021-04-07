{ lib, buildDunePackage, fetchFromGitHub, yojson }:

buildDunePackage rec {
  pname = "ppx_yojson_conv_lib";
  version = "0.14.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = "12s3xshayy1f8cp9lk6zqwnw60n7cdap55gkksz5w65gdd8bfxmf";
  };

  propagatedBuildInputs = [ yojson ];

  meta = with lib; {
    description = "Runtime lib for ppx_yojson_conv";
    homepage = "https://github.com/janestreet/ppx_yojson_conv_lib";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
