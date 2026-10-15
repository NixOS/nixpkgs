[
  # reason for failure: tests try to open display
  "test_background_color"
  "test_scene_add_remove"
  "test_Circle"
  "test_wait_skip"
  "test_basic_scene_with_default_values"
  "test_dry_run_with_png_format"
  "test_dry_run_with_png_format_skipped_animations"
  "test_FixedMobjects3D"
  "test_basic_scene_l_flag"
  "test_n_flag"
  "test_s_flag_opengl_renderer"
  "test_s_flag_no_animations"
  "test_image_output_for_static_scene"
  "test_no_image_output_with_interactive_embed"
  "test_no_default_image_output_with_non_static_scene"
  "test_image_output_for_static_scene_with_write_to_movie"
  "test_s_flag"
  "test_r_flag"
  "test_play_skip"
  "test_write_to_movie_disables_window"
  "test_a_flag"
  "test_pixel_coords_to_space_coords"
  "test_t_values"
  "test_custom_folders"
  "test_t_values[15]"
  "test_t_values[30]"
  "test_t_values[60]"
  "test_dash_as_filename"
  "test_images_are_created_when_png_format_set_for_opengl"
  "test_t_values_with_skip_animations"
  "test_static_wait_detection"
  "test_non_static_wait_detection"
  "test_frozen_frame"
  "test_gif_format_output"
  "test_animate_with_changed_custom_attribute"
  "test_images_are_zero_padded_when_zero_pad_set_for_opengl"
  "test_mp4_format_output"
  "test_videos_not_created_when_png_format_set"
  "test_images_are_created_when_png_format_set"
  "test_images_are_zero_padded_when_zero_pad_set"
  "test_webm_format_output"
  "test_default_format_output_for_transparent_flag"
  "test_mov_can_be_set_as_output_format"
  "test_force_window_opengl_render_with_format"
  "test_get_frame_with_preview_disabled"
  "test_get_frame_with_preview_enabled"

  # reason for failure: tests try to reach network
  "test_logging_to_file"

  # This tests checks if the manim executable is a python script. In our case it is not.
  # It is a wrapper shell script instead.
  "test_manim_checkhealth_subcommand"

  # failing with:
  # E       AssertionError: assert 'Manim Commun...developers.\n' == 'Manim Community v0.19.0\n\n'
  # E
  # E           Manim Community v0.19.0
  # E
  # E         + Usage: manim cfg [OPTIONS] COMMAND [ARGS]...
  # E         +
  # E         +   Manages Manim configuration files.
  # E         + ...
  # E
  # E         ...Full output truncated (9 lines hidden), use '-vv' to show
  "test_manim_cfg_subcommand"
]
