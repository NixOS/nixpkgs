{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  miniaudio,
  mlx,
  numpy,
  scipy,
  sounddevice,
  tqdm,
  transformers,

  # optional-dependencies
  fastapi,
  mlx-lm,
  mistral-common,
  python-multipart,
  sentencepiece,
  uvicorn,
  webrtcvad,
  zstandard,

  # tests
  ffmpeg-headless,
  httpx,
  httpx2,
  pytest-asyncio,
  pytestCheckHook,
  safetensors,
  writableTmpDirAsHomeHook,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlx-audio";
  version = "0.5.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Blaizzy";
    repo = "mlx-audio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sA5hz/FJfeMgIo2Fq53V9R3MqlEZL++x3cS3LaapMvY=";
  };

  patches = [
    # Fixture keeps Qwen's real token ids in embedding tables too small to hold them.
    ./icl-fixture-token-ids.patch
  ];

  # --verbose is store_true, so the default is False. The test expects True.
  postPatch = ''
    substituteInPlace mlx_audio/music/tests/test_generate.py \
      --replace-fail "verbose=True," "verbose=False,"
  '';

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    miniaudio
    mlx
    numpy
    scipy
    sounddevice
    tqdm
    transformers
  ];

  # webrtcvad is patched in nixpkgs, so drop the setuptools<81 pin.
  optional-dependencies =
    let
      self = finalAttrs.finalPackage.optional-dependencies;
    in
    {
      stt = [
        sentencepiece
        zstandard
      ];
      tts = [
        sentencepiece
      ]
      ++ mistral-common.optional-dependencies.audio;
      server = [
        fastapi
        python-multipart
        uvicorn
        webrtcvad
      ]
      ++ uvicorn.optional-dependencies.standard;
      sts = [
        mlx-lm
        sentencepiece
        webrtcvad
      ];
      llm = [
        mlx-lm
      ];
      # upstream pins mlx-lm==0.31.3
      parity = [
        mlx-lm
      ];
      all = self.stt ++ self.tts ++ self.server ++ self.sts ++ self.llm;
    };

  pythonImportsCheck = [ "mlx_audio" ];

  nativeCheckInputs = [
    ffmpeg-headless
    httpx
    httpx2
    pytest-asyncio
    pytestCheckHook
    safetensors
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.finalPackage.optional-dependencies.all
  ++ finalAttrs.finalPackage.optional-dependencies.parity;

  preCheck = ''
    export HF_HUB_OFFLINE=1
    export HF_DATASETS_OFFLINE=1
    export TRANSFORMERS_OFFLINE=1
  '';

  disabledTestPaths = [
    # RuntimeError: [metal_kernel] No Metal back-end.
    "mlx_audio/codec/tests/test_encodec.py::TestEncodec::test_encodec_24khz"
    "mlx_audio/sts/tests/test_mossformer2_se.py::TestMossFormer2SE::test_masknet_output_shape"
    "mlx_audio/stt/tests/test_phonon.py::test_base5_unpack_reconstructs_five_values"

    # ValueError: [new_stream] Cannot make gpu stream without gpu backend.
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_mlx_scheduler_keeps_arrays_on_one_stream_thread"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_pipeline_finalizes_turn_with_smart_turn_decision"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_pipeline_logs_empty_finalized_turn"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_echo_during_playback_is_suppressed_before_barge_in"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_persistent_speech_during_playback_waits_for_transcript"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_playback_candidate_matching_response_text_is_suppressed"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_vad_logging_emits_probability_events"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_logging_is_quiet_without_verbose"
    "mlx_audio/sts/tests/test_voice_pipeline.py::TestVoxtralRealtimePipelinePieces::test_vad_logging_skips_non_transition_silence_by_default"

    # queue.Empty
    # InferenceBroker._run calls mx.new_stream(mx.gpu)
    "mlx_audio/tests/test_server_inference.py"

    # hangs: TestClient waits on that worker
    "mlx_audio/tests/test_server.py::test_tts_speech"
    "mlx_audio/tests/test_server.py::test_tts_speech_bad_model_returns_404_not_silent_200"
    "mlx_audio/tests/test_server.py::test_tts_speech_load_failure_returns_500"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions_bad_model_returns_404"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions_default_format_preserves_ndjson"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions_response_format_json"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions_response_format_text"
    "mlx_audio/tests/test_server.py::test_stt_transcriptions_response_format_verbose_json"
    "mlx_audio/tests/test_server.py::test_stt_word_timestamps_passed_to_generate"
    "mlx_audio/tests/test_server.py::test_stt_word_timestamps_verbose_json_words_passthrough"

    # Downloads mlx-community/encodec-24khz-float32.
    "mlx_audio/codec/tests/test_vocos.py::TestVocos::test_vocos_24khz"
    "mlx_audio/tts/tests/test_models.py::TestBarkPipeline"

    # Downloads mlx-community/snac_24khz at import.
    "mlx_audio/music/tests/test_minimax_music3.py::test_official_tree_converts_and_loads_in_every_mlx_quantization_mode"
    "mlx_audio/stt/tests/test_parakeet_redux.py::test_generic_converter_redirects_to_lossless_converter"
    "mlx_audio/tts/tests/test_models.py::TestLlamaModel"
    "mlx_audio/tts/tests/test_models.py::TestQwen3Model"

    # Downloads mlx-community/whisper-tiny-asr-fp16.
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestStreamingDecoder::test_initialization"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestStreamingDecoder::test_reset_clears_state"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestDecodeChunk::test_decode_chunk_returns_result"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestDecodeChunk::test_decode_chunk_accumulates_audio"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestGenerateStreaming::test_generate_streaming_is_generator"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestGenerateStreaming::test_generate_streaming_final_result"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestGenerateStreaming::test_generate_streaming_auto_language_detection"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestStreamingIntegration::test_streaming_produces_results"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestStreamingIntegration::test_streaming_lower_latency_than_batch"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestSharedHelpers::test_prepare_audio_from_path"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestSharedHelpers::test_prepare_audio_from_array"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestSharedHelpers::test_detect_language_returns_code"
    "mlx_audio/stt/models/whisper/tests/test_streaming.py::TestSharedHelpers::test_detect_language_respects_override"

    # Downloads mlx-community/descript-audio-codec-44khz.
    "mlx_audio/tts/tests/test_models.py::TestDiaModel::test_init"

    # OSError: mlx-community/IndexTTS/tokenizer.model not found
    "mlx_audio/tts/tests/test_models.py::TestIndexTTS::test_init"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text-to-speech, speech-to-text and speech-to-speech library built on Apple's MLX framework";
    homepage = "https://github.com/Blaizzy/mlx-audio";
    changelog = "https://github.com/Blaizzy/mlx-audio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Kh05ifr4nD ];
  };
})
