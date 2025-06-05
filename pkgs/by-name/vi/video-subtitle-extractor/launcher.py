#!/usr/bin/env python3
import sys
import os

# The launcher script is in $out/bin, but the application data is in $out/share.
# We need to determine the correct application directory and change to it.
launcher_path = os.path.abspath(__file__)
bin_dir = os.path.dirname(launcher_path)
app_dir = os.path.normpath(os.path.join(bin_dir, "..", "share", "video-subtitle-extractor"))

# Fallback for development: if app_dir doesn't exist, assume we are running from the source root.
if not os.path.isdir(os.path.join(app_dir, "backend")):
    app_dir = os.path.dirname(os.path.abspath(__file__))

# Setup config directory
config_dir = os.path.expanduser("~/.config/video-subtitle-extractor")
os.makedirs(config_dir, exist_ok=True)

# Copy typoMap.json if needed
typo_map_file = os.path.join(config_dir, "typoMap.json")
if not os.path.exists(typo_map_file):
    src_typo_map = os.path.join(app_dir, "backend", "configs", "typoMap.json")
    if os.path.exists(src_typo_map):
        import shutil

        shutil.copy2(src_typo_map, typo_map_file)
        os.chmod(typo_map_file, 0o644)

# Setup paths
sys.path.insert(0, app_dir)
os.chdir(app_dir)

# PaddlePaddle initialization deferred to backend to prevent segfaults
print("✓ PaddlePaddle initialization will be handled by backend")

# Keep ProcessManager active as recommended by developer
try:
    from backend.tools.process_manager import ProcessManager

    # Initialize ProcessManager but disable ALL atexit handlers to prevent segfaults
    pm_instance = ProcessManager.instance()
    # Completely disable atexit handlers that cause PaddlePaddle cleanup segfaults
    import atexit

    atexit._clear()  # Remove all atexit handlers including PaddlePaddle's
    print("✓ ProcessManager initialized, atexit handlers disabled for safety")
except:
    pass

# Start GUI
try:
    import multiprocessing
    from PySide6.QtWidgets import QApplication
    import gui

    if __name__ == "__main__":
        # Darwin requires 'spawn' method, Linux can use 'spawn' too for consistency
        multiprocessing.set_start_method("spawn", force=True)
        app = QApplication(sys.argv)
        window = gui.SubtitleExtractorGUI()
        window.show()

        exit_code = app.exec()

        # IMMEDIATELY clean up ALL threads before any Qt cleanup starts
        try:
            from backend.tools.process_manager import ProcessManager

            ProcessManager.instance().terminate_all()
            print("✓ ProcessManager cleanup completed before Qt cleanup")
        except:
            pass

        # Immediately exit to prevent Qt/Wayland cleanup segfaults
        # This must be called BEFORE any Qt objects start their cleanup
        os._exit(exit_code)

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
