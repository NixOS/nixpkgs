{ lib, fetchFromGitHub, fetchpatch, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "18-08-3";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = version;
    sha256 = "1rymx106xa99wd4n44s7jw0w41spg39y1ji4fgn01yk7wjfrdrwg";
  };

  # Needed for patch below to apply
  prePatch = ''
    sed -i -e '/__max_slurm_hex_version__ = "0x1208/c__max_slurm_hex_version__ = "0x120804"' setup.py
  '';

  patches = [
    # Implements a less strict slurm version check
    (fetchpatch {
      url = "https://github.com/PySlurm/pyslurm/commit/d3703f2d58b5177d29092fe1aae1f7a96da61765.diff";
      sha256 = "1s41z9bhzhplgg08p1llc3i8zw20r1479s04y0l1vx0ak51b6w0k";
    })
  ];

  buildInputs = [ cython slurm ];
  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

  # Test cases need /etc/slurm/slurm.conf and require a working slurm installation
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/PySlurm/pyslurm;
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = [ maintainers.veprbl ];
  };
}
