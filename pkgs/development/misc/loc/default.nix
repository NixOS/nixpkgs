{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  version = "0.3.0";
  name = "loc-${version}";

  src = fetchFromGitHub {
    owner = "caga";
    repo = "loc";
    rev = "v0.3.0";
    sha256 = "1ckrf77s1glrqi0gvrv9wqmip4i97dk0arn0iz87jg4q2wfss85k";
  };

  depsSha256 = "1ckrf77s1glrqi0gvrv9wqmip4i97dk0arn0iz87jg4q2wfss85k";

  meta = {
    homepage = "http://github.com/cgag/loc";
    description = "Count lines of code quickly";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

