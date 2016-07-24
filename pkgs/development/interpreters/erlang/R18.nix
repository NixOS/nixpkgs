{ mkDerivation, fetchurl }:

let
  rmAndPwdPatch = fetchurl {
     url = "https://github.com/erlang/otp/commit/98b8650d22e94a5ff839170833f691294f6276d0.patch";
     sha256 = "0cd5pkqrigiqz6cyma5irqwzn0bi17k371k9vlg8ir31h3zmqfip";
  };

  envAndCpPatch = fetchurl {
     url = "https://github.com/binarin/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
     sha256 = "10h5348p6g279b4q01i5jdqlljww5chcvrx5b4b0dv79pk0p0m9f";
  };

in mkDerivation {
  version = "18.3.4";
  sha256 = "1f8nhybzsdmjvkmkzpjj3wj9jzx8mihlvi6gfp47fxkalansz39h";

  patches = [
    rmAndPwdPatch
    envAndCpPatch
  ];
}
