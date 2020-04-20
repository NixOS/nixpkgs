{ fetchpatch, mkDerivation }:

let
  _fetchpatch =
    { rev, sha256 }:
    fetchpatch {
      url = "https://github.com/rvirding/lfe/commit/${rev}.patch";
      inherit sha256;
    };
  fetchPatches = map _fetchpatch;
in

mkDerivation {
  version = "1.3";
  sha256 = "0pgwi0h0d34353m39jin8dxw4yykgfcg90k6pc4qkjyrg40hh4l6";
  maximumOTPVersion = "21";
  patches = fetchPatches [
    {
      rev = "b457e5d521bb35008e6049fab31b4073cc10d583";
      sha256 = "1zrq1b3291xhb0jsirgb5s8hacq5xvz7xidsp29aqcnpazdvivdc";
    }
    {
      rev = "5fe9f37741b7d53bd43109fd3435e1437f124a0d";
      sha256 = "1anqlcbih52lc0wynf58r67w1jhn264lz49rczwgh19pqg92dvqf";
    }
    {
      rev = "b8f3e06511cb6805cf3a904c1589b27f33f3958d";
      sha256 = "1zqafc0asm9m6cq7r0brvfawv69fqggy1phif3zknjmpicf25pqf";
    }
    {
      rev = "40c239a608460e55563edb68c1b6faca57518b54";
      sha256 = "03av5115jwyammw337xzy50l6api5h0wbwwda5vzw0w10zwb2z8y";
    }
    {
      rev = "5faa7106419263689bfc0bc08a7451ccb1fba718";
      sha256 = "0ml5yh5b3rn4ympks4bpx409hkra0i79zvq80azk0kmbjd869fxp";
    }
    {
      rev = "9ff978693babcfd043d741b5c6940920b8315892";
      sha256 = "04968dmp527wbkdv7dqpaj3nsyjls93whc1b5hx73b39dvl3n3y1";
    }
  ];
}
