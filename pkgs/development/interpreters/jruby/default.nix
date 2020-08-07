{ callPackage, lib }:
rec {

  rubyVersion = import ../ruby/ruby-version.nix { inherit lib; };

  generic_jruby =  {version, sha256, rubyVersion}: callPackage ./generic.nix {
    inherit version;
    inherit sha256;
    inherit rubyVersion;
  };

  v9_2_12_0 = generic_jruby {
    version = "9.2.12.0";
    sha256 = "013c1q1n525y9ghp369z1jayivm9bw8c1x0g5lz7479hqhj62zrh";
    rubyVersion = rubyVersion "2" "5" "7" "";
  };

  v9_2_13_0 = generic_jruby {
    version = "9.2.13.0";
    sha256 = "0n5glz6xm3skrfihzn3g5awdxpjsqn2k8k46gv449rk2l50w5a3k";
    rubyVersion = rubyVersion "2" "5" "7" "";
  };

  # jruby tracks the latest
  latest = v9_2_13_0;
}
