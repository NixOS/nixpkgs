{ stdenv, fetchFromGitHub, fetchurl, pythonPackages, which, bash, cmake, git }:

stdenv.mkDerivation rec {
  pname = "quickder";
  name = "${pname}-${version}";
  version = "1.2-2";

  src = fetchFromGitHub {
    sha256 = "0bd8x4acfswpq3hrqmp22mfqq2l60swmybmki69jayzxb5m96p3w";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "quick-der";
  };

  buildInputs = [ which bash cmake git ];
  propagatedBuildInputs = with pythonPackages; [ pyparsing asn1ate ];

    buildPhase = with pythonPackages; ''
      mkdir -p "$out/lib/${python.libPrefix}/site-packages"
      export PYTHONPATH="${asn1ate}/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
      cmake .
    '';

  meta = with stdenv.lib; {
    description = "Quick (and Easy) DER, a Library for parsing ASN.1";
    homepage = "https://github.com/vanrein/quick-der";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
