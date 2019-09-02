{ stdenv
, fetchFromGitHub
}:

let
  pname = "libco";
  version = "unstable-20190821";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "b8b70b0cf5d6c6521174001133bb4fde6cce761a";
    sha256 = "0wf6lhk72iq37h32s8sf373z45cls86rk66dsnq0d130s3clx93q";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    description = "libco is a cooperative multithreading library written in C89";
    homepage = "https://github.com/CanonicalLtd/libco";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
