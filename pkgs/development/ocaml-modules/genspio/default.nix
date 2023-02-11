{ lib, fetchFromGitHub, buildDunePackage
, base, fmt
}:

buildDunePackage rec {
  pname = "genspio";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = pname;
    rev = "${pname}.${version}";
    sha256 = "sha256:1788cnn10idp5i1hggg4pys7k0w8m3h2p4xa42jipfg4cpj7shaf";
  };

  propagatedBuildInputs = [ base fmt ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://smondet.gitlab.io/genspio-doc/";
    description = "Typed EDSL to generate POSIX Shell scripts";
    license = licenses.asl20;
    maintainers = [ maintainers.alexfmpe ];
  };
}
