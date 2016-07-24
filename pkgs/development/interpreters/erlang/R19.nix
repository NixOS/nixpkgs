{ mkDerivation, fetchurl }:

let
  envAndCpPatch = fetchurl {
    url = "https://github.com/binarin/otp/commit/9f9841eb7327c9fe73e84e197fd2965a97b639cf.patch";
    sha256 = "10h5348p6g279b4q01i5jdqlljww5chcvrx5b4b0dv79pk0p0m9f";
  };

in mkDerivation {
  version = "19.0.2";
  sha256 = "1vsykghhzpgmc42jwj48crl11zzzpvrqvh2lk8lxfqbflzflxm6j";

  patches = [
    envAndCpPatch
  ];
}
