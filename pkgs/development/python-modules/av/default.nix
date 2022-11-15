{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, cython
, pkg-config
, setuptools

# runtime
, ffmpeg

# tests
, numpy
, pillow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "av";
  version = "10.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mikeboers";
    repo = "PyAV";
    rev = "v${version}";
    hash = "sha256-XcHP8RwC2iwD64Jc7SS+t9OxjFTsz3FbrnjMgJnN7Ak=";
  };

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
  ];

  buildInputs = [
    ffmpeg
  ];

  preCheck = ''
    # ensure we import the built version
    rm -r av
  '';

  checkInputs = [
    numpy
    pillow
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # Tests that want to download FATE data
    # https://github.com/PyAV-Org/PyAV/issues/955
    "--deselect=tests/test_audiofifo.py::TestAudioFifo::test_data"
    "--deselect=tests/test_codec_context.py::TestCodecContext::test_codec_tag"
    "--deselect=tests/test_codec_context.py::TestCodecContext::test_parse"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_aac"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_dnxhd"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_dvvideo"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_h264"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_mjpeg"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_mp2"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_mpeg1video"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_mpeg4"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_pcm_s24le"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_png"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_tiff"
    "--deselect=tests/test_codec_context.py::TestEncoding::test_encoding_xvid"
    "--deselect=tests/test_decode.py::TestDecode::test_decode_audio_sample_count"
    "--deselect=tests/test_decode.py::TestDecode::test_decoded_motion_vectors"
    "--deselect=tests/test_decode.py::TestDecode::test_decoded_motion_vectors_no_flag"
    "--deselect=tests/test_decode.py::TestDecode::test_decoded_time_base"
    "--deselect=tests/test_decode.py::TestDecode::test_decoded_video_frame_count"
    "--deselect=tests/test_encode.py::TestBasicAudioEncoding::test_transcode"
    "--deselect=tests/test_file_probing.py::TestAudioProbe::test_container_probing"
    "--deselect=tests/test_file_probing.py::TestAudioProbe::test_stream_probing"
    "--deselect=tests/test_file_probing.py::TestDataProbe::test_container_probing"
    "--deselect=tests/test_file_probing.py::TestDataProbe::test_stream_probing"
    "--deselect=tests/test_file_probing.py::TestSubtitleProbe::test_container_probing"
    "--deselect=tests/test_file_probing.py::TestSubtitleProbe::test_stream_probing"
    "--deselect=tests/test_file_probing.py::TestVideoProbe::test_container_probing"
    "--deselect=tests/test_file_probing.py::TestVideoProbe::test_stream_probing"
    "--deselect=tests/test_python_io.py::TestPythonIO::test_reading_from_buffer"
    "--deselect=tests/test_python_io.py::TestPythonIO::test_reading_from_buffer_no_see"
    "--deselect=tests/test_python_io.py::TestPythonIO::test_reading_from_file"
    "--deselect=tests/test_python_io.py::TestPythonIO::test_reading_from_pipe_readonly"
    "--deselect=tests/test_python_io.py::TestPythonIO::test_reading_from_write_readonl"
    "--deselect=tests/test_seek.py::TestSeek::test_decode_half"
    "--deselect=tests/test_seek.py::TestSeek::test_seek_end"
    "--deselect=tests/test_seek.py::TestSeek::test_seek_float"
    "--deselect=tests/test_seek.py::TestSeek::test_seek_int64"
    "--deselect=tests/test_seek.py::TestSeek::test_seek_middle"
    "--deselect=tests/test_seek.py::TestSeek::test_seek_start"
    "--deselect=tests/test_seek.py::TestSeek::test_stream_seek"
    "--deselect=tests/test_streams.py::TestStreams::test_selection"
    "--deselect=tests/test_streams.py::TestStreams::test_stream_tuples"
    "--deselect=tests/test_subtitles.py::TestSubtitle::test_movtext"
    "--deselect=tests/test_subtitles.py::TestSubtitle::test_vobsub"
    "--deselect=tests/test_videoframe.py::TestVideoFrameImage::test_roundtrip"
  ];

  disabledTests = [
    # urlopen fails during DNS resolution
    "test_writing_to_custom_io"
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
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
