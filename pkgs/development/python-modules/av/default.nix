{ lib
, stdenv
, buildPythonPackage
, cython
, fetchFromGitHub
, ffmpeg_5-headless
, numpy
, pillow
, pkg-config
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "av";
  version = "11.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mikeboers";
    repo = "PyAV";
    rev = "refs/tags/v${version}";
    hash = "sha256-pCKP+4ZmZCJcG7/Qy9H6aS4svQdgaRA9S1QVNWFYhSQ=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [
    ffmpeg_5-headless
  ];

  preCheck = ''
    # ensure we import the built version
    rm -r av
  '';

  nativeCheckInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  disabledTests = [
    # urlopen fails during DNS resolution
    "test_writing_to_custom_io"
    "test_decode_close_then_use"
    # Tests that want to download FATE data, https://github.com/PyAV-Org/PyAV/issues/955
    "test_vobsub"
    "test_transcode"
    "test_stream_tuples"
    "test_stream_seek"
    "test_stream_probing"
    "test_seek_start"
    "test_seek_middle"
    "test_seek_int64"
    "test_seek_float"
    "test_seek_end"
    "test_roundtrip"
    "test_reading_from_write_readonl"
    "test_reading_from_pipe_readonly"
    "test_reading_from_file"
    "test_reading_from_buffer"
    "test_reading_from_buffer_no_see"
    "test_parse"
    "test_movtext"
    "test_encoding_xvid"
    "test_encoding_tiff"
    "test_encoding_png"
    "test_encoding_pcm_s24le"
    "test_encoding_mpeg4"
    "test_encoding_mpeg1video"
    "test_encoding_mp2"
    "test_encoding_mjpeg"
    "test_encoding_h264"
    "test_encoding_dvvideo"
    "test_encoding_dnxhd"
    "test_encoding_aac"
    "test_decoded_video_frame_count"
    "test_decoded_time_base"
    "test_decoded_motion_vectors"
    "test_decode_half"
    "test_decode_audio_sample_count"
    "test_data"
    "test_container_probing"
    "test_codec_tag"
    "test_selection"
  ] ++ lib.optionals (stdenv.isDarwin) [
    # Segmentation Faults
    "test_encoding_with_pts"
    "test_bayer_write"
  ];

  disabledTestPaths = [
    # urlopen fails during DNS resolution
    "tests/test_doctests.py"
    "tests/test_timeout.py"
  ];

  pythonImportsCheck = [
    "av"
    "av.audio"
    "av.buffer"
    "av.bytesource"
    "av.codec"
    "av.container"
    "av._core"
    "av.datasets"
    "av.descriptor"
    "av.dictionary"
    "av.enum"
    "av.error"
    "av.filter"
    "av.format"
    "av.frame"
    "av.logging"
    "av.option"
    "av.packet"
    "av.plane"
    "av.stream"
    "av.subtitles"
    "av.utils"
    "av.video"
  ];

  meta = with lib; {
    description = "Pythonic bindings for FFmpeg/Libav";
    homepage = "https://github.com/mikeboers/PyAV/";
    changelog = "https://github.com/PyAV-Org/PyAV/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
