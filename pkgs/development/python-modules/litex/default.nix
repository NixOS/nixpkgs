{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  migen,
  packaging,
  pyserial,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "litex";
  version = "2026.08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litex";
    tag = finalAttrs.version;
    hash = "sha256-Z2QK3EvzZ/EypPzrOwhshInDXnDzG329p3+umkZpNX0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    migen
    packaging
    pyserial
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Need amaranth, LiteX's sister cores (which depend on litex), a RISC-V toolchain,
    # a simulator, git, /bin/bash or OpenOCD.
    "test/hdl/test_amaranth2v_converter.py"
    "test/soc/test_cpu_gowin_ae350_native.py"
    "test/soc/test_integration.py"
    "test/tools/test_litex_setup.py"
    "test/tools/test_litex_release.py"
    "test/tools/test_jtag_uart.py"
    "test/build/test_build_bundle.py::TestBuildBundle::test_remote_build_works_with_local_fake_transport"
    "test/build/test_efinix.py::test_load_efinity_env_sources_setup"
    "test/build/test_sim_verilator.py::TestSimVerilatorUserHooks::test_generate_sim_variables_adds_extra_sources"
    "test/cores/test_video.py::TestVideoFrameBufferHelpers::test_unsupported_dma_port_is_rejected"
    "test/cores/test_video.py::TestVideoFrameBufferData::test_pixel_order_matches_across_dma_backends"
    "test/soc/test_builder.py::TestBuilderGeneratedFiles::test_generate_includes_with_bios_writes_linker_files"
    "test/soc/test_builder.py::TestBuilderGeneratedFiles::test_variables_contents_escapes_makefile_paths_and_validates_console"
    "test/soc/test_cpu_gowin_ae350.py::TestGowinAE350::test_ethernet_buffers_do_not_overlap_csrs"
    "test/soc/test_soc.py::TestSoCVideoFrameBuffer::test_native_sdram_port_is_read_only"
    "test/soc/test_soc.py::TestSoC::test_spi_flash_exports_erase_geometry"
    # Compiles C with -Werror, which nixpkgs' format hardening breaks.
    "test/software/test_spiflash.py"
  ];

  pythonImportsCheck = [
    "litex"
    "litex.soc.integration.builder"
  ];

  meta = {
    description = "Framework to build FPGA cores and SoCs";
    homepage = "https://github.com/enjoy-digital/litex";
    changelog = "https://github.com/enjoy-digital/litex/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ gonsolo ];
  };
})
