{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "md4c";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "mity";
    repo = "md4c";
    rev = "release-${version}";
    sha256 = "0km84rmcrczq4n87ryf3ffkfbjh4jim361pbld0z8wgp60rz08dh";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C Markdown parser compliant to CommonMark";
    homepage = "https://github.com/mity/md4c/";
    license = licenses.mit;
    maintainers = with maintainers; [ euandreh ];
  };
}
