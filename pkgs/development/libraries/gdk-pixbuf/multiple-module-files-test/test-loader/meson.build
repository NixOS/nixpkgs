project('gdk-pixbuf-test-loader', 'c')

gdk_pixbuf = dependency('gdk-pixbuf-2.0')
outputColor = get_option('outputColor')

shared_library('test_loader',
  sources: ['loader.c'],
  dependencies: [gdk_pixbuf],
  install: true,
  c_args: ['-DPIXBUF_COLOR="' + outputColor + '"']
)