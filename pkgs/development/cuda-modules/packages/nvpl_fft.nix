{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvpl_fft";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
  ];

  meta = {
    description = "Perform Fast Fourier Transform (FFT) calculations on ARM CPUs";
    homepage = "https://developer.nvidia.com/nvpl";
    changelog = "https://docs.nvidia.com/nvpl/latest/fft/release_notes.html";
  };
}
