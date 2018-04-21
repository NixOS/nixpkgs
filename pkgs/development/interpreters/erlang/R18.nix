{ mkDerivation, fetchpatch }:

let
  rmAndPwdPatch = fetchpatch {
     url = "https://github.com/erlang/otp/commit/98b8650d22e94a5ff839170833f691294f6276d0.patch";
     sha256 = "0zjs7as83prgq4d5gaw2cmnajnsprdk8cjl5kklknx0pc2b3hfg5";
  };

  envAndCpPatch = fetchpatch {
     url = "https://github.com/erlang/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
     sha256 = "00fx5wc88ki3z71z5q4xzi9h3whhjw1zblpn09w995ygn07m9qhm";
  };

in mkDerivation rec {
  version = "18.3.4.8";
  sha256 = "16c0h25hh5yvkv436ks5jbd7qmxzb6ndvk64mr404347a20iib0g";

  patches = [
    rmAndPwdPatch
    envAndCpPatch
  ];
}
