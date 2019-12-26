import subprocess
from datetime import datetime
import threading
from time import sleep
import os
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

state_lock = threading.Lock()
blank_time = None

inhibition_lock = threading.Lock()
inhibition_cookie = 0
inhibitions = {}

xscreensaver_bin = '@XSCREENSAVER_BIN@'

def command_args(*args):
  return [ xscreensaver_bin + "xscreensaver-command" ] + list(args)

def command(*args):
  print("command:", args)
  subprocess.check_call(command_args(*args))

def Lock():
  command('-lock')

def Cycle():
  command('-cycle')

def SimulateUserActivity():
  command('-deactivate')

def Inhibit(app_name, reason):
  command('-deactivate')
  with inhibition_lock:
    cookie = inhibition_cookie
    inhibition_cookie += 1
    inhibitions[cookie] = ( app_name, reason )
    return cookie

def UnInhibit(cookie):
  with inhibition_lock:
    inhibitions.pop(cookie, None)

def Throttle(app_name, reason, cookie):
  # TODO, not sure if this is possible
  pass

def UnThrottle(cookie):
  # TODO, not sure if this is possible
  pass

def SetActive(activate):
  if activate:
    command('-activate')
  else:
    command('-deactivate')

def GetActive():
  with state_lock:
    return blank_time != None

def GetActiveTime():
  with state_lock:
    if blank_time == None:
      return 0
    else:
      time = datetime.now()
      return int((time - blank_time).total_seconds())

def GetSessionIdle():
  # TODO: is this possible to implement?
  return False

def GetSessionIdleTime():
  # TODO: is this possible to implement?
  return 0

class GnomeDbus(dbus.service.Object):
  def __init__(self, bus):
    bus_name = dbus.service.BusName('org.gnome.ScreenSaver', bus=bus)
    dbus.service.Object.__init__(self, bus_name, '/org/gnome/ScreenSaver')

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='', out_signature='')
  def Lock(self):
    Lock()

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='', out_signature='')
  def SimulateUserActivity(self):
    SimulateUserActivity()

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='', out_signature='b')
  def GetActive(self):
    return GetActive()

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='', out_signature='u')
  def GetActiveTime(self):
    return GetActiveTime()

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='b', out_signature='')
  def SetActive(self, activate):
    SetActive(activate)

  @dbus.service.method(dbus_interface='org.gnome.ScreenSaver', in_signature='sss', out_signature='')
  def ShowMessage(self, summary, body, icon):
    pass

  @dbus.service.signal(dbus_interface='org.gnome.ScreenSaver', signature='b')
  def ActiveChanged(self, active):
    pass

class FreedesktopDbus(dbus.service.Object):
  def __init__(self, bus):
    bus_name = dbus.service.BusName('org.freedesktop.ScreenSaver', bus=bus)
    dbus.service.Object.__init__(self, bus_name, '/org/freedesktop/ScreenSaver')

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='', out_signature='')
  def Lock(self):
    Lock()

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='', out_signature='')
  def SimulateUserActivity(self):
    SimulateUserActivity()

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='', out_signature='b')
  def GetActive(self):
    return GetActive()

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='', out_signature='u')
  def GetActiveTime(self):
    return GetActiveTime()

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='b', out_signature='')
  def SetActive(self, activate):
    SetActive(activate)

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='sss', out_signature='')
  def ShowMessage(self, summary, body, icon):
    pass

  @dbus.service.signal(dbus_interface='org.freedesktop.ScreenSaver', signature='b')
  def ActiveChanged(self, active):
    pass

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='', out_signature='u')
  def GetSessionIdleTime(self):
    return GetSessionIdleTime()

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='ss', out_signature='u')
  def Inhibit(self, app_name, reason):
    return Inhibit(app_name, reason)

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='u', out_signature='')
  def UnInhibit(self, cookie):
    UnInhibit(cookie)

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='ss', out_signature='u')
  def Throttle(self, app_name, reason):
    return Throttle(app_name, reason)

  @dbus.service.method(dbus_interface='org.freedesktop.ScreenSaver', in_signature='u', out_signature='')
  def UnThrottle(self, cookie):
    UnThrottle(cookie)

dbus_loop = DBusGMainLoop()
bus = dbus.SessionBus(mainloop=dbus_loop)
gnome_dbus = GnomeDbus(bus)
freedesktop_dbus = FreedesktopDbus(bus)

def ActiveChanged(active):
  gnome_dbus.ActiveChanged(active)
  freedesktop_dbus.ActiveChanged(active)

# If we have any inhibitions, repeatedly call -deactivate.
# TODO: Is this possible without polling?
def inhibitor():
  while True:
    with inhibition_lock:
      if inhibitions:
        command('-deactivate')

    sleep(40) # The minimum sleep time in xscreensaver is 1 minute, so this should keep it deactivated safely.

def watcher():
  watch_proc = subprocess.Popen(command_args("-watch"), stdout=subprocess.PIPE, universal_newlines=True)
  for line in watch_proc.stdout:
    event = line.split(' ')[0]
    if event == 'BLANK':
      with state_lock:
        blank_time = datetime.now()
        ActiveChanged(True)
    elif event == 'UNBLANK':
      with state_lock:
        blank_time = None
        ActiveChanged(False)

# def main():
  # Create a process group so that our subprocesses get cleaned up.
os.setpgrp()

xscreensaver_proc = subprocess.Popen([ xscreensaver_bin + "xscreensaver", "-no-splash" ])

inhibitor_thread = threading.Thread(None, inhibitor, daemon=True)
inhibitor_thread.start()

watcher_thread = threading.Thread(None, watcher, daemon=True)
watcher_thread.start()

loop = GLib.MainLoop()
loop.run()