{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcodec";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tplgy";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-k4EACtDOSkTXezTeFtVdM1EVJjvGga/IQSrvDzhyaXw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Header-only C++11 library for encode/decode functions as in RFC 4648";
    longDescription = ''
      Header-only C++11 library to encode/decode base64, base64url, base32,
      base32hex and hex (a.k.a. base16) as specified in RFC 4648, plus
      Crockford's base32.
    '';
    homepage = "https://github.com/tplgy/cppcodec";
    license = licenses.mit;
    maintainers = with maintainers; [ panicgh raitobezarius ];
  };
})
