from setuptools import setup

setup(
  name='gnome-xscreensaver',
  version='0.1.0',
  py_modules=['gnomexscreensaver'],
  install_requires=['pygobject', 'python-prctl'],
  entry_points='''
      [console_scripts]
      gnome-screensaver=gnomexscreensaver:main
  ''',
)