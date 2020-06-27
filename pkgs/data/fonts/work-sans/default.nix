{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "work-sans";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "weiweihuanghuang";
    repo = "Work-Sans";
    rev = "v${version}";
    sha256 = "1qpjfj4pkh03y3nc8d8sbnhpq4v4wh4z3w6mbp8mh740afamia10";
  };

  meta = with lib; {
    description = "A grotesque sans";
    homepage = "https://weiweihuanghuang.github.io/Work-Sans/";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
