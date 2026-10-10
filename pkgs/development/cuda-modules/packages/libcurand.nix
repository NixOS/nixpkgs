{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libcurand";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
    "stubs"
  ];

  meta = {
    description = "GPU-accelerated random number generation library";
    longDescription = ''
      The cuRAND library provides facilities that focus on the simple and efficient generation of high-quality
      pseudorandom and quasirandom numbers.
    '';
    homepage = "https://developer.nvidia.com/curand";
  };
}
