{ buildErlang, fetchgit }:

buildErlang {
  name = "erlang-katana";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/inaka/erlang-katana.git";
    sha256 = "13vkgk5mjlwqvg3jlv2yd8y0f7c8vy64wakps6pg7flcd2cky7aq";
  };
}