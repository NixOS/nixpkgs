project('libufdt', 'c',
  default_options : ['warning_level=2'])

libfdt_dep = dependency('libfdt')

sysdeps_inc = include_directories('sysdeps/include')
libufdt_sysdeps = static_library('ufdt_sysdeps',
  'sysdeps/libufdt_sysdeps_posix.c',
  include_directories : sysdeps_inc,
)
sysdeps_dep = declare_dependency(
  link_with : libufdt_sysdeps,
  include_directories : sysdeps_inc,
)

libufdt_inc = include_directories('include', '.')
libufdt = shared_library('ufdt',
  files(
    'ufdt_overlay.c',
    'ufdt_convert.c',
    'ufdt_node.c',
    'ufdt_node_pool.c',
    'ufdt_prop_dict.c',
  ),
  include_directories : [libufdt_inc, sysdeps_inc],
  dependencies : [libfdt_dep, sysdeps_dep],
  install : true,
)
libufdt_dep = declare_dependency(
  link_with : libufdt,
  include_directories : libufdt_inc,
  dependencies : [libfdt_dep, sysdeps_dep],
)

pkg = import('pkgconfig')
pkg.generate(libufdt)

install_headers(
  'include/libufdt.h',
  'include/ufdt_overlay.h',
  'include/ufdt_overlay_internal.h',
  'include/ufdt_node_pool.h',
  'include/ufdt_types.h',
  'sysdeps/include/libufdt_sysdeps.h',
)

test_inc = include_directories('tests/src')

ufdt_apply_overlay_exe = executable('ufdt_apply_overlay',
  files('tests/src/ufdt_overlay_test_app.c', 'tests/src/util.c'),
  include_directories : test_inc,
  c_args : ['-Wno-error=format'],
  dependencies : libufdt_dep,
  install : true,
)

# libfdt reference implementation used by tests for comparison
fdt_apply_overlay_exe = executable('fdt_apply_overlay',
  files('tests/src/fdt_overlay_test_app.c', 'tests/src/util.c'),
  include_directories : test_inc,
  c_args : ['-Wno-error=format'],
  dependencies : [libfdt_dep, sysdeps_dep],
)

test_env = environment()
test_env.prepend('PATH', meson.current_build_dir())
test_env.set('ANDROID_BUILD_TOP', '1') # run_tests.sh checks this is non-empty; any value satisfies it

test('libufdt', find_program('tests/run_tests.sh'),
  workdir : meson.current_source_dir() / 'tests',
  env     : test_env,
  depends : [fdt_apply_overlay_exe, ufdt_apply_overlay_exe],
)
