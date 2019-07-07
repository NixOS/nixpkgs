{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "packr";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = pname;
    rev = "v${version}";
    sha256 = "070hpnsr5w1r1cg9wl80cafmhkx4z3s29wq04fa7rk49hmwml4jy";
  };

  modSha256 = "0xvpk9jjcqac44s4fp0jwpljxvs0ypjwc5qfg0w90s2r7jn50fxn";

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
